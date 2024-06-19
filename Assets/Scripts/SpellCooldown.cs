using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class SpellCooldown : MonoBehaviour
{
    [Header("UI items for Spell Cooldown")]
    [Tooltip("Tooltip example")]
    [SerializeField]
    private Image imageCooldown;
    [SerializeField]
    private TMP_Text textCooldown;

    //variable for looking after the cooldown
    private bool isCoolDown = false;
    public float cooldownTime = 2.0f;
    private float cooldownTimer = 0.0f;
    [Header("IgnoreCooldownSet")]
    public KeyCode AbilityKey = KeyCode.None;
    public string AnimationTriggerName;
    public AnimationClip AnimationClip;
    public Test_2 SkillMenagerScript;
    public bool IgnoreCooldown = false;



    // Start is called before the first frame update
    void Start()
    {
        if (!IgnoreCooldown)
        {
            textCooldown.gameObject.SetActive(false);
            imageCooldown.fillAmount = 0.0f;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyUp(AbilityKey))
            SkillMenagerScript.AgentStop();
        if (Input.GetKeyUp(AbilityKey) && SkillMenagerScript.isAgentNotMoving() && SkillMenagerScript.IsSpellOver)
        {
            UseSpell();
        }
        else if (Input.GetKeyUp(AbilityKey) && SkillMenagerScript.isAgentNotMoving() && IgnoreCooldown)
            MakeSpell();

        if (isCoolDown && !IgnoreCooldown)
        {
            ApplyCooldown();
        }
    }

    void ApplyCooldown()
    {
        cooldownTimer -= Time.deltaTime;
        if (cooldownTimer < 0.0f)
        {
            isCoolDown = false;
            textCooldown.gameObject.SetActive(false);
            imageCooldown.fillAmount = 0.0f;
        }
        else
        {
            textCooldown.text = Mathf.RoundToInt(cooldownTimer).ToString();
            imageCooldown.fillAmount = cooldownTimer / cooldownTime;
        }

    }

    public bool UseSpell()
    {

        if (isCoolDown)
        {
            return false;
        }
        else
        {

            if (!IgnoreCooldown)
            {
                isCoolDown = true;
                textCooldown.gameObject.SetActive(true);
                cooldownTimer = cooldownTime;
                textCooldown.text = Mathf.RoundToInt(cooldownTimer).ToString();
                imageCooldown.fillAmount = 1.0f;
            }
            SkillMenagerScript.ClickRoutine(AnimationTriggerName, AnimationClip);
            return true;
        }
    }

    public void MakeSpell()
    {
        SkillMenagerScript.AgentStop();

        if (!IgnoreCooldown)
        {
            if (SkillMenagerScript.IsSpellOver)
            {
                UseSpell();
            }
        }
        else
        {
            SkillMenagerScript.ClickRoutine(AnimationTriggerName, AnimationClip, true);
        }
    }
}

